module Travis
  module Build
    class Script
      class Crystal < Script

        def configure
          super

          sh.fold 'crystal_install' do
            sh.echo 'Installing Crystal', ansi: :yellow

            sh.cmd %q(sudo sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-keys 09617FD37CC06B54')
            sh.cmd %q(sudo sh -c 'echo "deb http://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list')
            sh.cmd %q(sudo sh -c 'apt-get update')

            sh.cmd %q(sudo apt-get install crystal)

            sh.echo 'Installing Shards', ansi: :yellow

            sh.cmd %q(sudo sh -c "curl -sL https://github.com/ysbaddaden/shards/releases/latest | \
                      egrep -o '/ysbaddaden/shards/releases/download/v[0-9\.]*/shards.*linux_.*64.gz' | \
                      wget --base=http://github.com/ -i - -O - | \
                      gunzip > /usr/local/bin/shards && \
                      chmod +x /usr/local/bin/shards")
          end
        end

        def setup
          super

          sh.echo 'Crystal for Travis-CI is not officially supported, but is community maintained.', ansi: :green
          sh.echo 'Please file any issues using the following link', ansi: :green
          sh.echo '  https://github.com/travis-ci/travis-ci/issues/new?labels=community:crystal', ansi: :green
          sh.echo 'and mention \`@asterite\`, \`@jhass\`, \`@waj\` and \`@will\` in the issue', ansi: :green
        end

        def announce
          super

          sh.cmd 'crystal --version'
          sh.cmd 'crystal deps --version'
          sh.echo ''
        end

        def install
          sh.if '-f shard.yml' do
            sh.cmd "crystal deps"
          end
        end

        def script
          sh.cmd "crystal spec"
        end

      end
    end
  end
end
