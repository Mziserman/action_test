# frozen_string_literal: true

class DropSpoiledPartitions20240121233748 < ActiveRecord::Migration[7.0]

  def change
    Rails.configuration.partitioned_tables.each do |table|
      partition_names = Database::PartitionsForTable.new(table: table).call
      spoiled_tables(partition_names).each do |table_to_drop|
        Rails.logger.info("[#{self.class}##{__method__}] Dropping partition #{table_to_drop} from table #{table}")

        drop_table table_to_drop
      end
    end
  end

  private

    def spoiled_tables(partition_names)
      partition_names.select do |partition_name|
        input_date = partition_name.split('_').last
        Date.new(input_date[0, 4].to_i, input_date[4, 2].to_i, 1) <= spoil_date
      end
    end

    def spoil_date
      Time.zone.today - Rails.configuration.partition_spoil.to_i.months
    end

end
