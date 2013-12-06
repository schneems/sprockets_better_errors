require 'test_helper'

class InheritNavigationTest < ActiveSupport::IntegrationCase

  precompile_error_scenarios = %w(asset_path link_tag link_tag_no_extension)

  precompile_error_scenarios.each do |scenario|
    test "reference an asset not specified in precompile list: #{scenario}" do
      error = assert_raise(ActionView::Template::Error) do
        visit("/foo/#{scenario}_precompile_error")
      end
      assert_match "not_precompiled.js", error.message
    end
  end

  test 'fails if assets are not properly defining dependencies' do
    error = assert_raise(ActionView::Template::Error) do
      visit('/foo/no_reference_error')
    end
    assert_match "depends on 'application.css'", error.message
  end

  test 'no failure' do
    visit('/foo/no_errors')
  end
end
