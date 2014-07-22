require 'cuegrowler/version'
require 'rubycue'
require 'osaka'
require 'growl'

module Cuegrowler

  class ITunes

    def self.get_player_position
      Osaka::ScriptRunner.execute(%q(tell application "iTunes" to get the player position)).to_f
    end
     
    def self.get_track_description
      Osaka::ScriptRunner.execute(%q(tell application "iTunes" to get the current track's long description))
    end

  end

  module Tracklist

    class ITunes

      def get
        parse_tracklist(Cuegrowler::ITunes.get_track_description)
      end

      def to_s
        "From iTunes description"
      end

      protected
      def parse_tracklist(description)
        description.lines.map(&:strip)
          .map { |line| [line, line.match(/\[(\d+):(\d+):(\d+)\]/)] }
          .reject { |text, match| match.nil? }
          .map { |text, match| { text: text, time: tracklist_match_to_time(match) } }
      end
       
      def tracklist_match_to_time(m)
        m[1].to_f * 3600 + m[2].to_f * 60 + m[3].to_f
      end

    end

    class Cuesheet
      
      def initialize(filename)

        @filename = filename
        @data = []
        
        cuesheet = RubyCue::Cuesheet.new(File.read(filename))
        cuesheet.parse!

        cuesheet.songs.each_with_index do |song, index|
          time = song[:index].to_f
          text = "#{index + 1}. #{format time} #{song[:performer]} — #{song[:title]}"
          @data << { text: text, time: time }
        end

      end

      def get
        @data
      end

      def to_s
        "From cuesheet #{@filename}"
      end

      private
      def format(time)
        hours, time = time.divmod(3600)
        minutes, seconds = time.divmod(60)
        "[%d:%02d:%02d]" % [hours, minutes, seconds]
      end

    end

  end

  class Growler

    def initialize(player, tracklist)
      @current_position = -Float::INFINITY
      @player           = player
      @tracklist        = tracklist
    end

    def loop_forever!
      loop do
        tick
        sleep 2
      end
    end

    def tick
      update_position
      tracklist = @tracklist.get
      new_song = tracklist.reverse.find { |track|
          @last_position < track[:time] && track[:time] <= @current_position }
      notify(new_song) if new_song
    end

    protected

    def update_position
      @last_position = @current_position
      @current_position = @player.get_player_position
    end

    def notify(new_song)
      Growl.notify new_song[:text], name: 'cuegrowler', title: 'New Track'
      puts "\n[#{Time.now}]"
      puts new_song[:text]
    end

  end

  class << self

    def main
      player    = ITunes
      tracklist = if ARGV[0]
                    Tracklist::Cuesheet.new(ARGV[0])
                  else
                    Tracklist::ITunes.new
                  end

      puts "\n== Cuegrowler is running! =="
      puts "Player:    #{player}"
      puts "Tracklist: #{tracklist}"
      Growler.new(player, tracklist).loop_forever!
    end

  end

end
