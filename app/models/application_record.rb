class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  include Discard::Model

  default_scope -> { kept }

  scope :only_deleted, -> { with_discarded.discarded }

  after_discard :discard_all_dependent
  after_undiscard :undiscard_all_dependent

  def discard_all_dependent
    dependent_relations.each do |relation|
      public_send(relation).discard_all
    end
  end

  def undiscard_all_dependent
    dependent_relations.each do |relation|
      public_send(relation).with_discarded.undiscard_all
    end
  end

  def update_with_context(attributes, context)
    with_transaction_returning_status do
      assign_attributes(attributes)
      save(context: context)
    end
  end

  private

  def dependent_relations
    self.class.reflect_on_all_associations(:has_many)
        .select { |q| q.options[:dependent] == :destroy }
        .map(&:name)
  end
end
