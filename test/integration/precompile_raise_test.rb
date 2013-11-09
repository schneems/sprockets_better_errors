require 'test_helper'

class InheritNavigationTest < ActiveSupport::IntegrationCase

  test 'reference an asset not specified in precompile list' do
    error = assert_raise(ActionView::Template::Error) do
      visit('/foo/precompile_error')
    end
    assert_match "not_precompiled.js", error.message
  end

  test 'fails if assets are not properly defining dependencies' do
    error = assert_raise(ActionView::Template::Error) do
      visit('/foo/no_reference_error')
    end
    assert_match "depends on 'application.css'", error.message
  end

  # test 'erb' do
  #    error = assert_raise(ActionView::Template::Error) do
  #     visit('/foo/no_erb_tag_error')
  #   end
  # end

end
