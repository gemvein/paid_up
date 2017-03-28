# frozen_string_literal: true
namespace :system do
  desc 'Recreate database from seeds'
  task clean: :environment do
    time = Time.now
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['db:test:prepare'].invoke
    puts "========== Completed in #{(Time.now - time)} s =========="
  end
end
