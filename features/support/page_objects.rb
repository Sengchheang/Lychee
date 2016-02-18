module Capybara
  module PageObjects

    class MainPage
      include Capybara::DSL
      extend RSpec::Matchers::DSL

      def has_logo?
        find("a.navbar-brand")
      end

      def main_menu
        find("DIV#sidebar UL.nav")
      end

      def has_breadcrumb?
        find("DIV.breadcrumbs#breadcrumbs")
      end

      Capybara.add_selector(:row) do
        xpath { |num| ".//table[@id='dataTable']/tbody/tr[#{num}]" }
      end

      Capybara.add_selector(:icon) do
        css { |title| "a[class='red'][title='#{title}']" }
      end

      # @see http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests
      matcher :have_social_media_links do |text|
        match_for_should { |node| node.find(:row, 1).find(:icon, title, match: :first, :text => text) }
        match_for_should_not { |node| node.has_no_selector(:row, 1).find(:icon, title, match: :first, :text => text) }
      end
    end
  end
end
