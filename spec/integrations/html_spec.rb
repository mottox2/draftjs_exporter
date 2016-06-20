# frozen_string_literal: true
require 'spec_helper'
require 'draftjs_exporter/html'
require 'draftjs_exporter/entities/link'

RSpec.describe DraftjsExporter::HTML do
  subject(:mapper) do
    described_class.new(
      entity_decorators: {
        'LINK' => DraftjsExporter::Entities::Link.new
      },
      block_map: {
        'header-one' => { element: 'h1' },
        'unordered-list-item' => {
          element: 'li',
          wrapper: ['ul', { className: 'public-DraftStyleDefault-ul' }]
        },
        'unstyled' => { element: 'div' }
      },
      style_map: {
        'ITALIC' => { fontStyle: 'italic' }
      }
    )
  end

  describe '#call' do
    it 'decodes the content_state to html' do
      input = {
        entityMap: {
          '0' => {
            type: 'LINK',
            mutability: 'MUTABLE',
            data: {
              url: 'http://example.com'
            }
          }
        },
        blocks: [
          {
            key: '5s7g9',
            text: 'Header',
            type: 'header-one',
            depth: 0,
            inlineStyleRanges: [],
            entityRanges: []
          },
          {
            key: 'dem5p',
            text: 'some paragraph text',
            type: 'unstyled',
            depth: 0,
            inlineStyleRanges: [
              {
                offset: 0,
                length: 4,
                style: 'ITALIC'
              }
            ],
            entityRanges: [
              {
                offset: 5,
                length: 9,
                key: 0
              }
            ]
          }
        ]
      }

      expected_output = <<-OUTPUT.strip
<h1>Header</h1><div>
<span style="fontStyle: italic;">some</span> <a href="http://example.com">paragraph</a> text</div>
      OUTPUT

      expect(mapper.call(input)).to eq(expected_output)
    end
  end
end
