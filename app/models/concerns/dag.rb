module Dag
  # Be a directed acyclic graphs (DAG).
  extend ActiveSupport::Concern

  included do
    # @return [Enumerable] all the ancestors of self.
    def ancestors
      parents + parents.map(&:ancestors).flatten
    end

    # @return [Enumerable] self and all the ancestors of self.
    def and_ancestors
      ancestors.prepend(self)
    end

    # @return [Enumerable] all the descendants of self.
    def descendants
      children + children.map(&:descendants).flatten
    end

    # @return [Enumerable] self and all the descendants of self.
    def and_descendants
      descendants.prepend(self)
    end
  end

  class_methods do
  end
end
