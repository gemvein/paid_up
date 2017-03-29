# frozen_string_literal: true

module PaidUp
  # PaidUp Install Generator
  class InstallGenerator < Rails::Generators::Base
    argument :user_model_name, type: :string, default: 'User'
    source_root File.expand_path('../templates', __FILE__)
    require File.expand_path('../../utils', __FILE__)
    include Generators::Utils
    include Rails::Generators::Migration

    def hello
      output 'PaidUp Installer will now install itself', :magenta
    end

    # all public methods in here will be run in order

    def install_devise
      output(
        'To start with, Devise is used to authenticate users. No need to '\
          "install it separately, I'll do that now.", :magenta
      )
      generate('devise:install')
      generate('devise User')
    end

    def install_cancan
      output(
        "For authorization, PaidUp uses CanCanCan. Let's get you started "\
          'with a customizable ability.rb file.',
        :magenta
      )
      template 'ability.rb', 'app/models/ability.rb'
    end

    def install_rolify
      output(
        "To provide varying roles for Users, we'll use Rolify. Let's set that "\
          'up now.',
        :magenta
      )
      generate('rolify', 'Role User')
    end

    def add_initializer
      output(
        "Next, you'll need an initializer.  This is where you put your "\
          'configuration options.',
        :magenta
      )
      template 'initializer.rb', 'config/initializers/paid_up.rb'
    end

    def add_migrations
      output 'Next come migrations.', :magenta
      rake 'paid_up:install:migrations'
    end

    def add_to_model
      output 'Adding PaidUp to your User model', :magenta
      gsub_file 'app/models/user.rb', /^\n  subscriber$/, ''
      inject_into_file(
        'app/models/user.rb', "\n  subscriber",
        after: 'class User < ActiveRecord::Base'
      )
    end

    def add_route
      output 'Adding PaidUp to your routes.rb file', :magenta
      gsub_file(
        'config/routes.rb',
        %r{mount PaidUp::Engine => '/.*', as: 'paid_up'},
        ''
      )
      route("mount PaidUp::Engine => '/', as: 'paid_up'")
    end
  end
end
