class AddConsonantsToDictionaryWord < ActiveRecord::Migration[5.0]
  def change
    if column_exists? :dictionary_words, :hash_integer
      remove_column :dictionary_words, :hash_integer, :integer
    end
  end
end
