defmodule InkplateAvm.Http do
  @url_regex ~r/
    ^(?<scheme>[A-Za-z][A-Za-z0-9+.\-]*)
    :\/\/
    (?<host>[^\/]+)
    (?<path>\/.*)?
  $/x

  def get(scheme, host, path) do
    with {:ok, conn} <-
           :ahttp_client.connect(
             String.to_atom(scheme),
             host,
             443,
             verify: :verify_none,
             active: false
           ),
         {:ok, conn, _ref} <- :ahttp_client.request(conn, "GET", path, [], nil),
         {:ok, _conn, response} <- :ahttp_client.recv(conn, 0) do
      data =
        response
        |> Enum.find(fn
          {:data, _, data} -> true
          _ -> false
        end)
        |> then(fn {:data, _, data} -> data end)

      status =
        response
        |> Enum.find(fn
          {:status, _, status} -> true
          _ -> false
        end)
        |> then(fn {:status, _, status} -> status end)

      header =
        response
        |> Enum.find(fn
          {:header, _, header} -> true
          _ -> false
        end)
        |> then(fn {:header, _, header} -> header end)

      %{status: status, header: header, data: data}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end
end
