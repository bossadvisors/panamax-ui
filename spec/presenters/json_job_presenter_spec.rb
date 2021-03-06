require 'spec_helper'

describe JsonJobPresenter do

  let(:view_context) { ActionView::Base.new }

  subject(:presenter) { described_class.new(view_context) }

  describe '#title' do
    subject { presenter.title }

    it { should eq '{{name}}' }
  end

  describe '#destroy_path' do
    before do
      view_context.stub(:jobs_path).and_return('/destroy/path')
    end
    it 'returns the job_path' do
      expect(subject.destroy_path).to eq '/destroy/path/{{key}}'
    end
  end

  describe '#status' do
    subject { presenter.status }

    it { should eq '{{status}}' }
  end

  describe '#dom_id' do
    subject { presenter.dom_id }

    it { should eq 'job_{{id}}' }
  end

  describe '#message' do
    its(:message) do
      should eq '{{#if success}}' +
        I18n.t('jobs.completion.success_async') +
        '{{else}}' +
        '{{#if failure}}' +
        I18n.t('jobs.completion.failure') +
        '{{/if}}' +
        '{{/if}}'
    end
  end

  describe '#steps' do
    it 'wraps the injected template with the handlebar tags' do
      result = subject.steps do |option_one, option_two|
        "NAME:#{option_one}STATUS:#{option_two}END"
      end
      expect(result).to eq('{{#each steps}}NAME:{{this.name}}STATUS:{{this.status}}END{{/each}}')
    end
  end
end
