module Bosh::Cli::Command
  class DeploymentDiff < Base
    def initialize(director, manifest)
      @director = director
      @manifest = manifest
    end

    def print(options)
      begin
        changes = @director.diff_deployment(@manifest.name, @manifest.yaml)
        diff = changes['diff']

        header('Detecting deployment changes')

        diff.each do |line_diff|
          formatted_line_diff, state = line_diff

          # colorization explicitly disabled
          if Bosh::Cli::Config.use_color?
            case state
              when 'added'
                say(formatted_line_diff.make_green)
              when 'removed'
                say(formatted_line_diff.make_red)
              else
                say(formatted_line_diff)
            end

          else
            case state
              when 'added'
                say('+ ' + formatted_line_diff)
              when 'removed'
                say('- ' + formatted_line_diff)
              else
                say('  ' + formatted_line_diff)
            end
          end
        end

        changes['context']
      rescue Bosh::Cli::ResourceNotFound
        inspect_deployment_changes(
          @manifest,
          redact_diff: options[:redact_diff]
        )

        nil
      end
    end
  end
end
