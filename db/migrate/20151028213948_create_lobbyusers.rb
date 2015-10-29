class CreateLobbyusers < ActiveRecord::Migration
  def change
    create_table :lobbyusers do |t|
      t.string :username

      t.timestamps null: false
    end
  end
end
