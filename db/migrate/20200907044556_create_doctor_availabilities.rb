class CreateDoctorAvailabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :doctor_availabilities do |t|
      t.date :date
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :is_available
      t.boolean :slot_occupied, default: 0
      t.text :reason_of_unavailability
      t.references :doctor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
