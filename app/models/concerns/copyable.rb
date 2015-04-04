require 'active_support/concern'

module Concerns
  module Copyable

    extend ActiveSupport::Concern

    PROTECTED = ['id', 'mongo_id', 'day_id', 'created_at', 'updated_at', 'trip_id', 'expendable_id', 'expendable_type',
      'linkable_id', 'linkable_type']

    def copy from, deep = false
      return if from.nil?
      copied_fields.each { |field| self.copy_field(field, from) }
      if deep
        self.reflections.keys.each do |relation|
          next if !copied_relations.include?(relation)
          next if from.send(relation).nil?

          if from.send(relation).is_a?(ActiveRecord::Associations::CollectionProxy)
            self.send(relation).destroy_all
            from.send(relation).each do |obj|
              self.send(relation).create(obj.attributes.reject{|k,_| !obj.copied_fields.include?(k)})
            end
          else
            self.send("#{relation}=", from.send(relation).class.new)
            self.send(relation).copy(from.send(relation), true) if !self.send(relation).nil?
            self.send(relation).save
          end
        end
      end
      self
    end

    def copy_field field, from
      self.send("#{field}=", from.send(field))
    end

    def copied_fields
      attributes.keys.reject{|v| PROTECTED.include?(v)}
    end

    def copied_relations
      []
    end

  end
end