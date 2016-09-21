class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :file_uid
      t.string :mime_type
      t.references :trip, foreign_key: true
      t.string :name
    end
  end
end
