task default: %w[test:test]

namespace :test do
  desc "Test Task"
  task :test do
    sh "echo 'test'"
  end
end


namespace :sass do
  desc "Watches and Generates CSS from SASS"
  task :watch do
    sh "sass --watch sass/main.scss:public/css/output.css"
  end
end
