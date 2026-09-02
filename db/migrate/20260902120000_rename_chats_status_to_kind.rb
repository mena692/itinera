class RenameChatsStatusToKind < ActiveRecord::Migration[8.1]
  def up
    rename_column :chats, :status, :kind

    execute "UPDATE chats SET kind = 'onboarding' WHERE kind = 'Draft'"
    execute "UPDATE chats SET kind = 'modification' WHERE kind IS NULL OR kind NOT IN ('onboarding', 'modification')"

    change_column_null :chats, :kind, false
  end

  def down
    change_column_null :chats, :kind, true
    rename_column :chats, :kind, :status
    execute "UPDATE chats SET status = 'Draft' WHERE status = 'onboarding'"
    execute "UPDATE chats SET status = NULL WHERE status = 'modification'"
  end
end
