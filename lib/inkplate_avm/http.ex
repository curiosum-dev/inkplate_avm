defmodule InkplateAvm.Http do
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
          {:data, _, _data} -> true
          _ -> false
        end)
        |> then(fn {:data, _, data} -> data end)

      status =
        response
        |> Enum.find(fn
          {:status, _, _status} -> true
          _ -> false
        end)
        |> then(fn {:status, _, status} -> status end)

      header =
        response
        |> Enum.find(fn
          {:header, _, _header} -> true
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
