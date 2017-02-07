ActiveAdmin.register_page "Dataset New" do
  menu :label => 'New Dataset'
  content do
    render partial: 'new'
  end
end
