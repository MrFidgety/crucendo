module Encryptable
  def encrypt_columns(*columns)
    columns.each do |column|
      if self.column_names.include?(column.to_s)
        define_method "#{column}=" do |value|
          self[column] = self.class.crypt.encrypt_and_sign(value)
        end

        define_method "#{column}" do
          unless self[column].blank?
            self.class.crypt.decrypt_and_verify(self[column])
          end
        end
        
        define_method "plain_#{column}=" do |value|
          self[column] = value
        end
      end
    end
  end

  def crypt
    @crypt ||= begin
      key = ActiveSupport::KeyGenerator.new(
              Rails.application.secrets.answer_key).generate_key(
              Rails.application.secrets.answer_salt)    
      ActiveSupport::MessageEncryptor.new(key)
    end
  end
end