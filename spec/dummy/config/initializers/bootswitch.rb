Bootswitch.configure do |config|
  # What helper method should determine the Bootswatch theme displayed?
  config.theme_method = :user_theme
  config.default_theme = 'slate'
  config.themes = ['amelia', 'cerulean', 'cosmo', 'custom', 'cyborg', 'darkly', 'flatly','global','journal','readable','simplex','slate','spacelab','superhero','united','yeti']
end

def user_theme
  nil
end