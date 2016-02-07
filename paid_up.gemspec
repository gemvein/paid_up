# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: paid_up 0.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "paid_up"
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Karen Lundgren"]
  s.date = "2016-02-07"
  s.description = "Allows a model of your choosing (such as users) to subscribe to a plan, which enables features."
  s.email = "karen.e.lundgren@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "LICENSE.txt",
    "MIT-LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "app/controllers/paid_up/paid_up_controller.rb",
    "app/controllers/paid_up/plans_controller.rb",
    "app/controllers/paid_up/subscriptions_controller.rb",
    "app/helpers/paid_up/features_helper.rb",
    "app/helpers/paid_up/paid_up_helper.rb",
    "app/helpers/paid_up/plans_helper.rb",
    "app/helpers/paid_up/subscriptions_helper.rb",
    "app/models/paid_up/ability.rb",
    "app/models/paid_up/plan.rb",
    "app/models/paid_up/plan_feature_setting.rb",
    "app/models/paid_up/unlimited.rb",
    "app/views/devise/confirmations/new.html.haml",
    "app/views/devise/passwords/edit.html.haml",
    "app/views/devise/passwords/new.html.haml",
    "app/views/devise/registrations/_new_form.html.haml",
    "app/views/devise/registrations/edit.html.haml",
    "app/views/devise/registrations/new.html.haml",
    "app/views/devise/sessions/_new_form.html.haml",
    "app/views/devise/sessions/new.html.haml",
    "app/views/devise/shared/_links.html.haml",
    "app/views/devise/unlocks/new.html.haml",
    "app/views/paid_up/features/_abilities_table.html.haml",
    "app/views/paid_up/features/_table.html.haml",
    "app/views/paid_up/plans/index.html.haml",
    "app/views/paid_up/subscriptions/index.html.haml",
    "app/views/paid_up/subscriptions/new.html.haml",
    "config/initializers/stripe.rb",
    "config/locales/en.yml",
    "config/routes.rb",
    "coverage/.last_run.json",
    "coverage/.resultset.json",
    "coverage/.resultset.json.lock",
    "db/migrate/20150407110101_create_paid_up_plans_table.rb",
    "db/migrate/20150519164237_add_stripe_id_column_to_users.rb",
    "db/migrate/20160207113800_create_paid_up_plan_feature_settings_table.rb",
    "lib/generators/paid_up/install/install_generator.rb",
    "lib/generators/paid_up/install/templates/ability.rb",
    "lib/generators/paid_up/install/templates/initializer.rb",
    "lib/generators/paid_up/utils.rb",
    "lib/paid_up.rb",
    "lib/paid_up/configuration.rb",
    "lib/paid_up/engine.rb",
    "lib/paid_up/extensions/integer.rb",
    "lib/paid_up/extensions/stripe.rb",
    "lib/paid_up/feature.rb",
    "lib/paid_up/localization.rb",
    "lib/paid_up/mixins/paid_for.rb",
    "lib/paid_up/mixins/subscriber.rb",
    "lib/paid_up/railtie.rb",
    "lib/paid_up/validators/rolify_rows.rb",
    "lib/paid_up/validators/table_rows.rb",
    "lib/paid_up/version.rb",
    "paid_up.gemspec",
    "spec/controllers/paid_up/plans_spec.rb",
    "spec/controllers/paid_up/subscriptions_spec.rb",
    "spec/dummy/Rakefile",
    "spec/dummy/app/assets/javascripts/application.js",
    "spec/dummy/app/assets/stylesheets/application.css.scss",
    "spec/dummy/app/controllers/application_controller.rb",
    "spec/dummy/app/models/ability.rb",
    "spec/dummy/app/models/doodad.rb",
    "spec/dummy/app/models/group.rb",
    "spec/dummy/app/models/role.rb",
    "spec/dummy/app/models/user.rb",
    "spec/dummy/app/views/layouts/application.html.haml",
    "spec/dummy/app/views/pages/index.html.haml",
    "spec/dummy/bin/bundle",
    "spec/dummy/bin/rails",
    "spec/dummy/bin/rake",
    "spec/dummy/bin/setup",
    "spec/dummy/config.ru",
    "spec/dummy/config/application.rb",
    "spec/dummy/config/boot.rb",
    "spec/dummy/config/database.yml",
    "spec/dummy/config/environment.rb",
    "spec/dummy/config/environments/development.rb",
    "spec/dummy/config/environments/production.rb",
    "spec/dummy/config/environments/test.rb",
    "spec/dummy/config/initializers/assets.rb",
    "spec/dummy/config/initializers/backtrace_silencers.rb",
    "spec/dummy/config/initializers/cookies_serializer.rb",
    "spec/dummy/config/initializers/devise.rb",
    "spec/dummy/config/initializers/filter_parameter_logging.rb",
    "spec/dummy/config/initializers/high_voltage.rb",
    "spec/dummy/config/initializers/inflections.rb",
    "spec/dummy/config/initializers/mime_types.rb",
    "spec/dummy/config/initializers/paid_up.rb",
    "spec/dummy/config/initializers/rolify.rb",
    "spec/dummy/config/initializers/session_store.rb",
    "spec/dummy/config/initializers/wrap_parameters.rb",
    "spec/dummy/config/locales/devise.en.yml",
    "spec/dummy/config/locales/en.yml",
    "spec/dummy/config/routes.rb",
    "spec/dummy/config/secrets.yml",
    "spec/dummy/coverage/.last_run.json",
    "spec/dummy/coverage/.resultset.json",
    "spec/dummy/coverage/.resultset.json.lock",
    "spec/dummy/db/development.sqlite3",
    "spec/dummy/db/migrate/20150406154440_create_users_table.rb",
    "spec/dummy/db/migrate/20150517175135_create_groups_table.rb",
    "spec/dummy/db/migrate/20150517175136_create_doodads_table.rb",
    "spec/dummy/db/migrate/20150523010827_add_devise_to_users.rb",
    "spec/dummy/db/migrate/20150523010837_rolify_create_roles.rb",
    "spec/dummy/db/migrate/20160207184112_create_paid_up_plans_table.paid_up.rb",
    "spec/dummy/db/migrate/20160207184113_add_stripe_id_column_to_users.paid_up.rb",
    "spec/dummy/db/migrate/20160207184114_create_paid_up_plan_feature_settings_table.paid_up.rb",
    "spec/dummy/db/schema.rb",
    "spec/dummy/db/seeds.rb",
    "spec/dummy/db/test.sqlite3",
    "spec/dummy/lib/assets/.keep",
    "spec/dummy/log/.keep",
    "spec/dummy/log/development.log",
    "spec/dummy/public/404.html",
    "spec/dummy/public/422.html",
    "spec/dummy/public/500.html",
    "spec/dummy/public/assets/.sprockets-manifest-34b01376fc56586f4f4fd19e7b1c0e35.json",
    "spec/dummy/public/assets/application-27f004bb902952dbbaad25f0f28c312f29ffee315c94fa51dea6b5ec6dc993e6.css",
    "spec/dummy/public/assets/application-3a226fbacd7ba9a2b9f7972fafdd7b2486c34707d96a60c26f3bbe4579c29ca6.js",
    "spec/dummy/public/assets/bootstrap/glyphicons-halflings-regular-13634da87d9e23f8c3ed9108ce1724d183a39ad072e73e1b3d8cbf646d2d0407.eot",
    "spec/dummy/public/assets/bootstrap/glyphicons-halflings-regular-42f60659d265c1a3c30f9fa42abcbb56bd4a53af4d83d316d6dd7a36903c43e5.svg",
    "spec/dummy/public/assets/bootstrap/glyphicons-halflings-regular-a26394f7ede100ca118eff2eda08596275a9839b959c226e15439557a5a80742.woff",
    "spec/dummy/public/assets/bootstrap/glyphicons-halflings-regular-e395044093757d82afcb138957d06a1ea9361bdcf0b442d06a18a8051af57456.ttf",
    "spec/dummy/public/assets/bootstrap/glyphicons-halflings-regular-fe185d11a49676890d47bb783312a0cda5a44c4039214094e7957b4c040ef11c.woff2",
    "spec/dummy/public/favicon.ico",
    "spec/factories/group.rb",
    "spec/factories/plan.rb",
    "spec/factories/plan_feature_setting.rb",
    "spec/factories/user.rb",
    "spec/models/group_spec.rb",
    "spec/models/paid_up/feature_spec.rb",
    "spec/models/paid_up/plan_feature_setting_spec.rb",
    "spec/models/paid_up/plan_spec.rb",
    "spec/models/user_spec.rb",
    "spec/paid_up_spec.rb",
    "spec/rails_helper.rb",
    "spec/routing/paid_up/plans_spec.rb",
    "spec/routing/paid_up/subscription_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/controller_macros.rb",
    "spec/support/factory_girl.rb",
    "spec/support/features.rb",
    "spec/support/groups.rb",
    "spec/support/loaded_site.rb",
    "spec/support/plans.rb",
    "spec/support/stripe.rb",
    "spec/support/users.rb",
    "spec/views/paid_up/plans_spec.rb",
    "spec/views/paid_up/subscriptions_spec.rb"
  ]
  s.homepage = "http://www.gemvein.com/museum/cases/paid_up"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "Allows a model of your choosing to subscribe to a plan, which enables features."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 4.2.5"])
      s.add_runtime_dependency(%q<rails-i18n>, ["~> 4"])
      s.add_runtime_dependency(%q<haml-rails>, ["~> 0.9"])
      s.add_runtime_dependency(%q<jquery-rails>, ["~> 4"])
      s.add_runtime_dependency(%q<uglifier>, ["~> 2.7"])
      s.add_runtime_dependency(%q<bootstrap_leather>, ["~> 0.5"])
      s.add_runtime_dependency(%q<chronic>, ["~> 0.10"])
      s.add_runtime_dependency(%q<money>, ["~> 6.5"])
      s.add_runtime_dependency(%q<devise>, ["~> 3.4"])
      s.add_runtime_dependency(%q<cancancan>, ["~> 1.10"])
      s.add_runtime_dependency(%q<rolify>, ["~> 4"])
      s.add_runtime_dependency(%q<stripe>, ["~> 1.21"])
      s.add_development_dependency(%q<jeweler>, ["~> 2"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3"])
      s.add_development_dependency(%q<forgery>, ["~> 0.6"])
      s.add_development_dependency(%q<bootstrap-sass>, ["~> 3.3"])
      s.add_development_dependency(%q<sass-rails>, ["~> 5.0"])
      s.add_development_dependency(%q<high_voltage>, ["~> 2.3"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 3.2"])
      s.add_development_dependency(%q<factory_girl_rails>, ["~> 4.5"])
    else
      s.add_dependency(%q<rails>, ["~> 4.2.5"])
      s.add_dependency(%q<rails-i18n>, ["~> 4"])
      s.add_dependency(%q<haml-rails>, ["~> 0.9"])
      s.add_dependency(%q<jquery-rails>, ["~> 4"])
      s.add_dependency(%q<uglifier>, ["~> 2.7"])
      s.add_dependency(%q<bootstrap_leather>, ["~> 0.5"])
      s.add_dependency(%q<chronic>, ["~> 0.10"])
      s.add_dependency(%q<money>, ["~> 6.5"])
      s.add_dependency(%q<devise>, ["~> 3.4"])
      s.add_dependency(%q<cancancan>, ["~> 1.10"])
      s.add_dependency(%q<rolify>, ["~> 4"])
      s.add_dependency(%q<stripe>, ["~> 1.21"])
      s.add_dependency(%q<jeweler>, ["~> 2"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3"])
      s.add_dependency(%q<forgery>, ["~> 0.6"])
      s.add_dependency(%q<bootstrap-sass>, ["~> 3.3"])
      s.add_dependency(%q<sass-rails>, ["~> 5.0"])
      s.add_dependency(%q<high_voltage>, ["~> 2.3"])
      s.add_dependency(%q<rspec-rails>, ["~> 3.2"])
      s.add_dependency(%q<factory_girl_rails>, ["~> 4.5"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 4.2.5"])
    s.add_dependency(%q<rails-i18n>, ["~> 4"])
    s.add_dependency(%q<haml-rails>, ["~> 0.9"])
    s.add_dependency(%q<jquery-rails>, ["~> 4"])
    s.add_dependency(%q<uglifier>, ["~> 2.7"])
    s.add_dependency(%q<bootstrap_leather>, ["~> 0.5"])
    s.add_dependency(%q<chronic>, ["~> 0.10"])
    s.add_dependency(%q<money>, ["~> 6.5"])
    s.add_dependency(%q<devise>, ["~> 3.4"])
    s.add_dependency(%q<cancancan>, ["~> 1.10"])
    s.add_dependency(%q<rolify>, ["~> 4"])
    s.add_dependency(%q<stripe>, ["~> 1.21"])
    s.add_dependency(%q<jeweler>, ["~> 2"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3"])
    s.add_dependency(%q<forgery>, ["~> 0.6"])
    s.add_dependency(%q<bootstrap-sass>, ["~> 3.3"])
    s.add_dependency(%q<sass-rails>, ["~> 5.0"])
    s.add_dependency(%q<high_voltage>, ["~> 2.3"])
    s.add_dependency(%q<rspec-rails>, ["~> 3.2"])
    s.add_dependency(%q<factory_girl_rails>, ["~> 4.5"])
  end
end

