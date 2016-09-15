class MoveAnswerContentToEncryptedAnswer < ActiveRecord::Migration
  def change
    Answer.all.each do |a|
      a.update_attributes!(encrypted_answer: a.content)
    end
  end
end
