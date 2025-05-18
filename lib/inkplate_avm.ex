defmodule InkplateAvm do
  def start() do
    :io.format(~c"Hello World~n")

    _sta_result =
      :network.wait_for_sta(
        [
          ssid: "HALNy-2.4G-0bbb82",
          psk: "u88WHuLc8u"
        ],
        15_000
      )

    case wait_for_network() do
      :ok ->
        :ssl.start()

        InkplateAvm.Http.get("https", "curiosum.com", "/")
        |> then(fn
          %{status: status, header: header, data: data} ->
            IO.puts("Status: #{status |> inspect()}")
            IO.puts("Header: #{header |> inspect()}")
            IO.puts("Data: #{data}")

          {:error, reason} ->
            IO.puts("Error: #{reason |> inspect()}")
        end)

      _ ->
        {:error, :network_not_connected}
    end
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
