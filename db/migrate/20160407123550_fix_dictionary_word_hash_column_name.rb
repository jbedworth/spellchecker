class FixDictionaryWordHashColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :dictionary_words, :hash, :hash_integer
  end
end
