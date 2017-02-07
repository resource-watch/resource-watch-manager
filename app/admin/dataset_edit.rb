ActiveAdmin.register_page "Dataset Edit" do
  menu :label => 'Edit Dataset'
  content do
    render partial: 'edit'
  end
end
