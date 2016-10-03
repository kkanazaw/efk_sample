#!/usr/bin/env ruby

require 'json'
require 'msgpack'
require 'net/http'

def get_json(uri,token, record)
  req = Net::HTTP::Get.new(uri.request_uri)
  req['PRIVATE-TOKEN'] = token
  res = Net::HTTP.start(uri.host, uri.port) do |http|
    http.request(req)
  end
  return JSON.parse(res.body)
end


token = "q18BbPUcj2ANXrL7Rrs1"
begin
  while line = STDIN.gets
    line.chomp!
    record = JSON.parse(line)

    commit_uri = URI.parse("http://192.168.1.7:10080/api/v3/projects/#{record['project_id']}/repository/commits/#{record['id']}")
    commit_result = get_json(commit_uri,token,record)
    diff_uri = URI.parse("http://192.168.1.7:10080/api/v3/projects/#{record['project_id']}/repository/commits/#{record['id']}/diff")
    diff_result = get_json(diff_uri,token,record) 
    record.merge!(commit_result)
    record["diff"] = diff_result

    STDOUT.print record.json
    STDOUT.flush
  end
rescue Interrupt
end
