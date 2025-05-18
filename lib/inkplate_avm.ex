defmodule InkplateAvm do
  def start() do
    case InkplateAvm.Network.connect("HALNy-2.4G-0bbb82", "u88WHuLc8u") do
      :ok ->
        :ssl.start()

        InkplateAvm.Http.get("https", "curiosum.com", "/")
        |> then(fn
          %{status: status, header: header, data: data} ->
            IO.puts("Status: #{status |> inspect()}")
            IO.puts("Header: #{header |> inspect()}")
            IO.puts("Data length: #{data |> byte_size()}")

          {:error, reason} ->
            IO.puts("Error: #{reason |> inspect()}")
        end)

      _ ->
        {:error, :network_not_connected}
    end
  end
end
