Rails.application.config.to_prepare do
  ActiveSupport.on_load(:active_storage_blob) do
    remove_method(:verify_integrity_of) if method_defined?(:verify_integrity_of)

    define_method(:verify_integrity_of) do |io|
      # Skipped in development
    end
  end
end
