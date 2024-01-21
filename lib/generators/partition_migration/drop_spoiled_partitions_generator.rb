# frozen_string_literal: true

module PartitionMigration
  class DropSpoiledPartitionsGenerator < Rails::Generators::Base

    source_root File.expand_path('templates', __dir__)

    def drop_partitions_migration
      timestamp = Time.zone.now.to_s.tr('^0-9', '')[0..13]

      @migration_class_name = "DropSpoiledPartitions#{timestamp}"

      template(
        'drop_spoiled_partitions.txt.erb',
        "db/migrate/#{timestamp}_drop_spoiled_partitions_#{timestamp}.rb",
      )
    end

  end
end
