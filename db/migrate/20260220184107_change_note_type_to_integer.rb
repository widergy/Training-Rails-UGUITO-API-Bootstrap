class ChangeNoteTypeToInteger < ActiveRecord::Migration[6.1]
  def up
    # 1. Add a temporary integer column
    # We use 'review' as the default (0)
    add_column :notes, :new_note_type, :integer, default: 0, null: false

    # 2. Map existing string data to the new integer column
    # Note: Using update_all to avoid loading all objects into memory for 3 records, 
    # but for safety in migrations with logic it's often better to iterate if count is small.
    # Since we only have 3, let's just do it directly.
    execute <<-SQL
      UPDATE notes SET new_note_type = 0 WHERE note_type = 'review';
      UPDATE notes SET new_note_type = 1 WHERE note_type = 'critique';
    SQL

    # 3. Remove the old string column and rename the new one
    remove_column :notes, :note_type
    rename_column :notes, :new_note_type, :note_type
  end

  def down
    # Revert to string if needed
    add_column :notes, :old_note_type, :string
    
    execute <<-SQL
      UPDATE notes SET old_note_type = 'review' WHERE note_type = 0;
      UPDATE notes SET old_note_type = 'critique' WHERE note_type = 1;
    SQL
    
    remove_column :notes, :note_type
    rename_column :notes, :old_note_type, :note_type
  end
end
