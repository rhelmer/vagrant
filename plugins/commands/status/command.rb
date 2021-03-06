require 'optparse'

module VagrantPlugins
  module CommandStatus
    class Command < Vagrant.plugin("2", :command)
      def execute
        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant status [machine-name]"
        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        state = nil
        results = []
        with_target_vms(argv) do |machine|
          state = machine.state if !state
          results << "#{machine.name.to_s.ljust(25)} #{machine.state.short_description} (#{machine.provider_name})"
        end

        message = nil
        if results.length == 1
          message = state.long_description
        else
          message = I18n.t("vagrant.commands.status.listing")
        end

        @env.ui.info(I18n.t("vagrant.commands.status.output",
                            :states => results.join("\n"),
                            :message => message),
                     :prefix => false)

        # Success, exit status 0
        0
      end
    end
  end
end
