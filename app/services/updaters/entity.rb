class Updaters::Entity

  def delete_nested collection, params
    to_delete = []
    collection.each do |item|
      to_delete << item.id if params.select { |v| v[:id].to_s == item.id.to_s }.count == 0
    end
    collection.where(:id => to_delete).destroy_all
  end

  def process_nested(collection, params, nested_list = [])
    delete_nested collection, params
    params.each do |item_hash|

      item_id = (item_hash.delete(:id).to_i % 2147483647) rescue nil
      item = collection.where(id: item_id).first unless item_id.nil?

      nested_hash = {}
      nested_list.each do |nested_attr|
        nested_hash[nested_attr] = item_hash.delete(nested_attr)
      end

      process_amount(item_hash)
      if item.blank?
        item = collection.create(item_hash)
      else
        item.update_attributes(item_hash)
      end

      nested_hash.each do |attr, values|
        process_nested(item.send(attr), values) if values.present?
      end
    end
  end

  def process_ordered(params)
    params.each_with_index do |item_hash, index|
      item_hash['order_index'] = index
    end
  end

  def process_amount item_hash
    (item_hash['amount_cents'] = item_hash['amount_cents'].to_i rescue nil) unless item_hash['amount_cents'].nil?
  end

end