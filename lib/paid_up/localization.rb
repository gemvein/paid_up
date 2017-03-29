# frozen_string_literal: true

# String Extension
module StringExtension
  def localize(*args)
    sym = if args.first.is_a? Symbol
            args.shift
          else
            underscore.tr(' ', '_').gsub(/[^a-z0-9_]+/i, '').to_sym
          end
    args << { default: self }

    I18n.t(sym, *args).html_safe
  end
  alias l localize
end
String.send :include, StringExtension

# Symbol Extensions
module SymbolExtensionCustom
  def localize_with_debugging(*args)
    localized_sym = I18n.translate(self, *args)
    localized_sym.is_a?(String) ? localized_sym.html_safe : localized_sym
  end
  alias l localize_with_debugging

  def l_with_args(*args)
    l(*args).html_safe
  end
end

Symbol.send :include, SymbolExtensionCustom
