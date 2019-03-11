ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        div class: "blank_slate_container", id: "dashboard_default_message" do
          span class: "blank_slate" do
            span (User.all.count)
            small ("Total Users")
          end

          span class: "blank_slate" do
            span (Note.all.count)
            small ("Total Notes")
          end

          span class: "blank_slate" do
            span (Comment.all.count)
            small ("Total User Comments")
          end
        end
      end
    end
    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
