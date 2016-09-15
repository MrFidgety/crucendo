class AddEncryptedAnswerToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :encrypted_answer, :text
  end
end
