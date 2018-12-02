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

        def self.recommendation(must_channels_id, good_channels_id, ok_channels_id, packages)
          packages = packages.map { |p| {"id": p.id, "cost": p.cost, "channel_ids": p.channels.ids } }
          must = packages.map { |p| p[:channel_ids] & must_channels_id }
          good = packages.map { |p| p[:channel_ids] & (must_channels_id | good_channels_id) }
          ok = packages.map { |p| p[:channel_ids] & (must_channels_id | good_channels_id | ok_channels_id) }
          costs = packages.map { |p| p[:cost] }
          must_idx = self.getWeightedSetCover(must, costs)
          good_idx = self.getWeightedSetCover(good, costs)
          ok_idx = self.getWeightedSetCover(ok, costs)

          return packages.values_at(*must_idx), packages.values_at(*good_idx), packages.values_at(*ok_idx)
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
