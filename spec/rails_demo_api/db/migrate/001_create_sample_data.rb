class CreateSampleData < ActiveRecord::Migration[8.0]
  def change
    # This is a placeholder migration for the API demo
    # Add any sample tables needed for testing here
    
    # Example: create a simple table for testing StompBase models functionality
    create_table :sample_records do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: true
      t.timestamps
    end
    
    add_index :sample_records, :name
    add_index :sample_records, :active
  end
end