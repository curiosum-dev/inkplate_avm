defmodule InkplateAvm.Network do
  def connect(ssid, psk) do
    :network.wait_for_sta(
      [
        ssid: ssid,
        psk: psk
      ],
      15_000
    )

    wait_for_network()
  end

  defp wait_for_network do
    receive do
      :disconnected ->
        IO.puts("Disconnected from network")
        wait_for_network()

      :connected ->
        IO.puts("Connected to network")
        wait_for_network()

      {:ok, {ip, _mask, _gateway}} ->
        IO.puts("Got IP: #{inspect(ip)}")
        :ok

      msg ->
        IO.puts("Received: #{msg |> inspect()} \n")
        wait_for_network()
    after
      10_000 ->
        IO.puts("Timeout waiting for network connection")
    end
  end
end
