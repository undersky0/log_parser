require_relative '../../spec_helper'
require_relative '../../../services/parsers/log_parser'

describe Services::Parsers::LogParser do

  let(:log)         { File.expand_path(File.dirname(__FILE__) + '../../../support/test_files/webserver.log') }
  let(:log_parser)  { described_class.new(log) }

  describe "#perform" do

    subject { log_parser.perform }

    context "with valid log file" do
      before do
        subject
      end

      it "return correct path and visit count ordered by visit count" do

        first_path = log_parser.results[:path_visits].first[:path]
        first_path_visits = log_parser.results[:path_visits].first[:visits]

        expect(first_path).to eq("/about/2")
        expect(first_path_visits).to eq(90)
      end

      it "return correct uniq path and uniq visit count ordered by visit count" do
        first_uniq_path = log_parser.results[:uniq_path_visits].first[:path]
        first_uniq_path_visits = log_parser.results[:uniq_path_visits].first[:uniq_views]

        expect(first_uniq_path).to eq("/contact")
        expect(first_uniq_path_visits).to eq(10)
      end
    end

    context "with invalid log" do

      let(:log) { "invalid" }

      it "raises an invalid file error" do
        expect{ subject }.to raise_error(Error::InvalidFile)
      end
    end

    context "with empty log" do

      let(:log) { File.expand_path(File.dirname(__FILE__) + '../../../support/test_files/empty.log') }

      it "raises an empty file error" do
        expect{ subject }.to raise_error(Error::EmptyFile)
      end
    end
  end
end