class AddRewriteSuffixToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :rewrite_suffix, :string
  end

  def self.down
    remove_column :pages, :rewrite_suffix
  end
end