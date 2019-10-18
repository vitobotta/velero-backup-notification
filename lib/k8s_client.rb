module Kubernetes
  class Client
    KUBE_CONFIG = ENV.fetch("KUBE_CONFIG", "")
    KUBE_HOST = ENV.fetch("KUBE_HOST", "kubernetes.default.svc.cluster.local")
    KUBE_PORT = ENV.fetch("KUBE_PORT", "443")

    def initialize
      @client = KUBE_CONFIG.empty? ? K8s::Client.in_cluster_config : K8s::Client.config(K8s::Config.load_file(KUBE_CONFIG), server: "https://#{KUBE_HOST}:#{KUBE_PORT}")
    end

    private

    attr_reader :client

    def method_missing(method, *args)
      if client.respond_to?(method)
        client.send(method, *args)
      else
        super
      end
    end
  end
end
