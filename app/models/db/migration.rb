module Db
  class Migration

    include Mongoid::Document
    include Mongoid::Timestamps

    module RunsTypes
      ONCE = 'once'
      FOREVER = 'forever'
      NEVER = 'never'
    end

    field :class_name, type: String
    field :runs_type, type: String
    field :last_run_at, type: DateTime
    field :run_times, type: Integer, default: 0
    field :error, type: String

    def self.registrate!(hash = {})
      #skip all_tasks
      all.update_all(runs_type: RunsTypes::NEVER)

      #update_tasks
      hash.each do |class_name, type|
        task = by_class_name(class_name)
        task.runs_type = type || RunsTypes::NEVER
        task.save
      end
    end

    def self.run_all!
      count = 0
      all.each do |task|
        if task.need?
          count += 1 if task.run!
        end
      end
      count
    end

    def self.find(class_name)
      where(class_name: class_name).first
    end

    def run!
      puts "Task for #{class_name} running"
      class_name.constantize.perform
      self.last_run_at = Time.now
      self.run_times += 1
      self.error = nil
      save
      puts "Task for #{class_name} finished"
      true
    rescue Exception => e
      puts e
      set(error: e.inspect)
      false
    end

    def need?
      return true if forever?
      return true if once? && run_times.zero?
      false
    end

    def once?
      runs_type == RunsTypes::ONCE
    end

    def forever?
      runs_type == RunsTypes::FOREVER
    end

    private

    def self.by_class_name(class_name)
      where(class_name: class_name).first || new(class_name: class_name)
    end

  end
end