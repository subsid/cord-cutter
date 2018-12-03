require 'pqueue'
require 'set'

MAXPRIORITY = 999999

class User < ApplicationRecord
        has_many :channels_users
        has_many :channels, :through => :channels_users  # Edit :needs to be plural same as the has_many relationship

        def self.find_or_create_from_auth_hash(auth)
                where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
                        user.provider = auth.provider
                        user.uid = auth.uid
                        user.first_name = auth.info.first_name
                        user.last_name = auth.info.last_name
                        user.email = auth.info.email
                        user.picture = auth.info.image
                        user.save!
                end
        end

        def add_channels(channel_ids, preference)
          if channel_ids
            channel_ids.each do |id|
              c_obj = Channel.find(id)
              self.channels_users.build :preferences => preference, :channel_id => c_obj.id
            end
          end
        end

        ## TODO Cleanup code
        def self.recommendation(must_channel_ids, good_channel_ids, ok_channel_ids, packages, budget)
          must_channel_ids = must_channel_ids.map(&:to_i)
          good_channel_ids = good_channel_ids.map(&:to_i)
          ok_channel_ids = ok_channel_ids.map(&:to_i)

          packages = packages.map { |p| { id: p.id, name: p.name, cost: p.cost, channel_ids: p.channels.ids } }
          must = packages.map { |p| p[:channel_ids] & must_channel_ids }
          good = packages.map { |p| p[:channel_ids] & (must_channel_ids | good_channel_ids) }
          ok = packages.map { |p| p[:channel_ids] & (must_channel_ids | good_channel_ids | ok_channel_ids) }
          costs = packages.map { |p| p[:cost] || 1 }
          must_idx = self.getWeightedSetCover(must, costs)
          good_idx = self.getWeightedSetCover(good, costs)
          ok_idx = self.getWeightedSetCover(ok, costs)

          must = packages.values_at(*must_idx)
          good = packages.values_at(*good_idx)
          ok = packages.values_at(*ok_idx)

          rec = [
           {
            count: [(must_channel_ids & must.map {|p| p[:channel_ids]}.flatten).length, must_channel_ids.length],
            must_count: [(must_channel_ids & must.map {|p| p[:channel_ids]}.flatten).length, must_channel_ids.length],
            good_count: [(good_channel_ids & must.map {|p| p[:channel_ids]}.flatten).length, good_channel_ids.length],
            ok_count: [(ok_channel_ids & must.map {|p| p[:channel_ids]}.flatten).length, ok_channel_ids.length],
            must_channels: Channel.find(must_channel_ids & must.map {|p| p[:channel_ids]}.flatten),
            good_channels: Channel.find(good_channel_ids & must.map {|p| p[:channel_ids]}.flatten),
            ok_channels: Channel.find(ok_channel_ids & must.map {|p| p[:channel_ids]}.flatten),
            packages: must,
            class: must.map{ |p| p[:cost] }.sum <= budget.to_f ? "positive" : "negative"
           },{
            count: [((must_channel_ids | good_channel_ids) & good.map {|p| p[:channel_ids]}.flatten).length, must_channel_ids.length + good_channel_ids.length],
            must_count: [(must_channel_ids & good.map {|p| p[:channel_ids]}.flatten).length, must_channel_ids.length],
            good_count: [(good_channel_ids & good.map {|p| p[:channel_ids]}.flatten).length, good_channel_ids.length],
            ok_count: [(ok_channel_ids & good.map {|p| p[:channel_ids]}.flatten).length, ok_channel_ids.length],
            must_channels: Channel.find(must_channel_ids & good.map {|p| p[:channel_ids]}.flatten),
            good_channels: Channel.find(good_channel_ids & good.map {|p| p[:channel_ids]}.flatten),
            ok_channels: Channel.find(ok_channel_ids & good.map {|p| p[:channel_ids]}.flatten),
            packages: good,
            class: good.map{ |p| p[:cost] }.sum <= budget.to_f ? "positive" : "negative"
           },{
            count: [((must_channel_ids | good_channel_ids | ok_channel_ids) & ok.map {|p| p[:channel_ids]}.flatten).length, must_channel_ids.length + good_channel_ids.length + ok_channel_ids.length],
            must_count: [(must_channel_ids & ok.map {|p| p[:channel_ids]}.flatten).length, must_channel_ids.length],
            good_count: [(good_channel_ids & ok.map {|p| p[:channel_ids]}.flatten).length, good_channel_ids.length],
            ok_count: [(ok_channel_ids & ok.map {|p| p[:channel_ids]}.flatten).length, ok_channel_ids.length],
            must_channels: Channel.find(must_channel_ids & ok.map {|p| p[:channel_ids]}.flatten),
            good_channels: Channel.find(good_channel_ids & ok.map {|p| p[:channel_ids]}.flatten),
            ok_channels: Channel.find(ok_channel_ids & ok.map {|p| p[:channel_ids]}.flatten),
            packages: ok,
            class: ok.map{ |p| p[:cost] }.sum <= budget.to_f ? "positive" : "negative"
           }]

          return rec.uniq {|r| r[:packages]}
        end

        def self.getWeightedSetCover(s, w)
          udict = {}
          selected = []
          scopy = [] # During the process, S will be modified. Make a copy for s.

          s.each_with_index do |item, index|
              scopy.push(Set.new(item))
              item.each do |j|
                  if not udict.key?(j)
                      udict[j] = Set[]
                  end
                  udict[j].add(index)
              end
          end

          pq = PQ.new()
          cost = 0
          coverednum = 0

          scopy.each_with_index do |item, index|
              if item.length() == 0
                  pq.push(index, MAXPRIORITY)
              else
                  pq.push(index, w[index].to_f / item.length())
              end
          end

          while coverednum < udict.length()
              a = pq.pop
              selected.push(a)
              cost += w[a]
              coverednum += scopy[a].length()

              # Update the sets that contains the new covered elements
              scopy[a].each do |m|
                  udict[m].each do |n|
                      if n != a
                          scopy[n].delete(m)
                          if scopy[n].length() == 0
                              pq.push(n, MAXPRIORITY)
                          else
                              pq.push(n, w[n].to_f / scopy[n].length())
                          end
                      end
                  end
              end

              scopy[a].clear()
              pq.push(a, MAXPRIORITY)
          end
          return selected
        end
end

class PQ
  @pq = []
  @latest_priority = {}

  def initialize ()
      @pq = PQueue.new([]){ |a, b| a[1] < b[1] }
      @latest_priority = {}
  end

  def push (k, priority)
      @latest_priority[k] = priority
      @pq.push([k, priority])
  end

  def pop
      while @pq.size > 0
          k, p = @pq.pop
          if @latest_priority[k] == p
              return k
          end
      end
  end
end
