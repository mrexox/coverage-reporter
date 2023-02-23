require "../../spec_helper"

Spectator.describe CoverageReporter::CoberturaParser do
  subject { described_class.new(base_path) }

  let(base_path) { nil }

  describe "#matches?" do
    it "matches correct filenames" do
      expect(subject.matches?("cobertura.xml")).to eq true
      expect(subject.matches?("path/coverage-report/cobertura.xml")).to eq true

      expect(subject.matches?("cobertura.json")).to eq false
    end
  end

  describe "#parse" do
    let(filename) { "spec/fixtures/cobertura/cobertura.xml" }

    it "parses the data correctly" do
      reports = subject.parse(filename)

      expect(reports.size).to eq 16
      expect(reports[0].name).to match /^org\/scoverage\//
      with_branches = reports.find! { |report| report.name == "org/scoverage/samples/SimpleObject2.scala" }

      expect(with_branches.coverage).to eq [
        nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, nil, nil,
        0, nil, 0, nil, 1, nil, 1, 0, 0, 0, nil, nil, nil, nil, 1, 0, 0, 1, 1,
      ] of Int64?
      expect(with_branches.branches).to eq [
        15, 1, 0, 0,
        17, 2, 0, 0,
        19, 3, 0, 1,
        21, 4, 0, 1,
        22, 5, 0, 0,
        30, 6, 0, 0,
        31, 7, 0, 0,
        32, 8, 0, 1,
        33, 9, 0, 1,
      ] of Int64?
    end

    context "with base_path" do
      let(base_path) { "src/main/scala" }

      it "joins with base_path" do
        reports = subject.parse(filename)

        expect(reports[0].name).to match /^src\/main\/scala\/org\/scoverage\//
      end
    end
  end
end
