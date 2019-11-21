require_relative '../../helpers/db'

describe DB do
  let(:db) { DB.new }
  let(:pg_connection_string) { { :hostaddr => Secrets.db_hostaddress, :dbname => Secrets.db_name, :user => Secrets.db_username, :password => Secrets.db_password } }
  let(:pg) { double('pg') }

  before do
    allow(Secrets).to receive(:db_hostaddress)
    allow(Secrets).to receive(:db_name)
    allow(Secrets).to receive(:db_username)
    allow(Secrets).to receive(:db_password)
    allow(PG).to receive(:connect).with(pg_connection_string).and_return(pg)
  end

  describe 'add_entry' do
    let(:pg_input) { "INSERT INTO basstracker (date, time, angler, event, weight, weight_decimal, weight_oz) VALUES('11/20/2019', '09:41 AM', 'jason.vue', 'b5', '3-12', '3.75', '60')" }
    it 'returns true (successful)' do
      expect(pg).to receive(:exec).with(pg_input)
      expect(pg).to receive(:result_status).and_return(1)
      expect(db.add_entry('11/20/2019', '09:41 AM', 'jason.vue', 'b5', '3-12', '3.75', 60)).to be_truthy
    end
  end
end
