class PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :summary, :body, :contact_email, :contact_name, :featured
end
