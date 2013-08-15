module SpreeGiftCard
  module Generators
    class InstallGenerator < Rails::Generators::Base

      def add_javascripts
        append_file "app/assets/javascripts/store/all.js", "\n//= require store/spree_gift_card"
        append_file "app/assets/javascripts/admin/all.js", "\n//= require admin/spree_gift_card"
      end

      def add_stylesheets
        store_ext = File.exists?("app/assets/stylesheets/store/all.css") ? ".css" : ".css.scss"
        admin_ext = File.exists?("app/assets/stylesheets/admin/all.css") ? ".css" : ".css.scss"
        inject_into_file "app/assets/stylesheets/store/all#{store_ext}", "\n *= require store/spree_gift_card", :after => "*= require_tree .", :verbose => true
        inject_into_file "app/assets/stylesheets/admin/all#{admin_ext}", "\n *= require admin/spree_gift_card", :after => "*= require_tree .", :verbose => true
      end

      def add_migrations
        run 'rake railties:install:migrations FROM=spree_gift_card'
      end

      def run_migrations
        res = ask "Would you like to run the migrations now? [Y/n]"
        if res == "" || res.downcase == "y"
          run 'rake db:migrate'
        else
          puts "Skipping rake db:migrate, don't forget to run it!"
        end
      end

    end
  end
end
