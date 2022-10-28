export APP_BITCOIN_TESTNET_IP="10.21.220.2"
export APP_BITCOIN_TESTNET_NODE_IP="10.21.210.8"

export APP_BITCOIN_TESTNET_DATA_DIR="${EXPORTS_APP_DIR}/data/bitcoin"
export APP_BITCOIN_TESTNET_RPC_PORT="18332"
export APP_BITCOIN_TESTNET_P2P_PORT="18333"
export APP_BITCOIN_TESTNET_TOR_PORT="18334"
export APP_BITCOIN_TESTNET_ZMQ_RAWBLOCK_PORT="58332"
export APP_BITCOIN_TESTNET_ZMQ_RAWTX_PORT="58333"
export APP_BITCOIN_TESTNET_ZMQ_HASHBLOCK_PORT="58334"
export APP_BITCOIN_TESTNET_ZMQ_SEQUENCE_PORT="58335"

APP_BITCOIN_CHAIN="test"
APP_BITCOIN_TESTNET_NETWORK="testnet"
BITCOIN_TESTNET_ENV_FILE="${EXPORTS_APP_DIR}/.env"

if [[ ! -f "${BITCOIN_TESTNET_ENV_FILE}" ]]; then
echo "here 1"
	if [[ -z ${BITCOIN_RPC_USER+x} ]] || [[ -z ${BITCOIN_RPC_PASS+x} ]] || [[ -z ${BITCOIN_RPC_AUTH+x} ]]; then
echo "here 2"
                APP_BITCOIN_TESTNET_RPC_USER="umbrel"
		APP_BITCOIN_TESTNET_RPC_DETAILS=$("${EXPORTS_APP_DIR}/scripts/rpcauth.py" "${APP_BITCOIN_TESTNET_RPC_USER}")
		APP_BITCOIN_TESTNET_RPC_PASS=$(echo "$APP_BITCOIN_TESTNET_RPC_DETAILS" | tail -1)
		APP_BITCOIN_TESTNET_RPC_AUTH=$(echo "$APP_BITCOIN_TESTNET_RPC_DETAILS" | head -2 | tail -1 | sed -e "s/^rpcauth=//")
	fi

	echo "export APP_BITCOIN_TESTNET_NETWORK='${APP_BITCOIN_TESTNET_NETWORK}'"      >  "${BITCOIN_TESTNET_ENV_FILE}"
	echo "export APP_BITCOIN_TESTNET_RPC_USER='${APP_BITCOIN_TESTNET_RPC_USER}'"	>> "${BITCOIN_TESTNET_ENV_FILE}"
	echo "export APP_BITCOIN_TESTNET_RPC_PASS='${APP_BITCOIN_TESTNET_RPC_PASS}'"	>> "${BITCOIN_TESTNET_ENV_FILE}"
	echo "export APP_BITCOIN_TESTNET_RPC_AUTH='${APP_BITCOIN_TESTNET_RPC_AUTH}'"	>> "${BITCOIN_TESTNET_ENV_FILE}"
fi

. "${BITCOIN_TESTNET_ENV_FILE}"


BIN_ARGS=()
BIN_ARGS+=( "-chain=${APP_BITCOIN_CHAIN}" )
BIN_ARGS+=( "-proxy=${TOR_PROXY_IP}:${TOR_PROXY_PORT}" )
BIN_ARGS+=( "-listen" )
BIN_ARGS+=( "-bind=0.0.0.0:${APP_BITCOIN_TESTNET_TOR_PORT}=onion" )
BIN_ARGS+=( "-bind=${APP_BITCOIN_TESTNET_NODE_IP}" )
BIN_ARGS+=( "-port=${APP_BITCOIN_TESTNET_P2P_PORT}" )
BIN_ARGS+=( "-rpcport=${APP_BITCOIN_TESTNET_RPC_PORT}" )
BIN_ARGS+=( "-rpcbind=${APP_BITCOIN_TESTNET_NODE_IP}" )
BIN_ARGS+=( "-rpcbind=127.0.0.1" )
BIN_ARGS+=( "-rpcallowip=${NETWORK_IP}/16" )
BIN_ARGS+=( "-rpcallowip=192.168.1.0/24" )
BIN_ARGS+=( "-rpcallowip=127.0.0.1" )
BIN_ARGS+=( "-rpcauth=\"${APP_BITCOIN_TESTNET_RPC_AUTH}\"" )
BIN_ARGS+=( "-zmqpubrawblock=tcp://0.0.0.0:${APP_BITCOIN_TESTNET_ZMQ_RAWBLOCK_PORT}" )
BIN_ARGS+=( "-zmqpubrawtx=tcp://0.0.0.0:${APP_BITCOIN_TESTNET_ZMQ_RAWTX_PORT}" )
BIN_ARGS+=( "-zmqpubhashblock=tcp://0.0.0.0:${APP_BITCOIN_TESTNET_ZMQ_HASHBLOCK_PORT}" )
BIN_ARGS+=( "-zmqpubsequence=tcp://0.0.0.0:${APP_BITCOIN_TESTNET_ZMQ_SEQUENCE_PORT}" )
BIN_ARGS+=( "-txindex=1" )
BIN_ARGS+=( "-blockfilterindex=1" )
BIN_ARGS+=( "-peerbloomfilters=1" )
BIN_ARGS+=( "-peerblockfilters=1" )
BIN_ARGS+=( "-rpcworkqueue=128" )

export APP_BITCOIN_TESTNET_COMMAND=$(IFS=" "; echo "${BIN_ARGS[@]}")

# echo "${APP_BITCOIN_TESTNET_COMMAND}"

rpc_hidden_service_file="${EXPORTS_TOR_DATA_DIR}/app-${EXPORTS_APP_ID}-rpc/hostname"
p2p_hidden_service_file="${EXPORTS_TOR_DATA_DIR}/app-${EXPORTS_APP_ID}-p2p/hostname"
export APP_BITCOIN_TESTNET_RPC_HIDDEN_SERVICE="$(cat "${rpc_hidden_service_file}" 2>/dev/null || echo "notyetset.onion")"
export APP_BITCOIN_TESTNET_P2P_HIDDEN_SERVICE="$(cat "${p2p_hidden_service_file}" 2>/dev/null || echo "notyetset.onion")"

# electrs compatible network param
export APP_BITCOIN_TESTNET_NETWORK_ELECTRS=$APP_BITCOIN_TESTNET_NETWORK

