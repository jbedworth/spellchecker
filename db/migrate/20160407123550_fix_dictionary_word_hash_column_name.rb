class FixDictionaryWordHashColumnName < ActiveRecord::Migration[5.0]
  def change
    if column_exists? :dictionary_words, :hash
      rename_column :dictionary_words, :hash, :hash_integer
    end
  end
end
