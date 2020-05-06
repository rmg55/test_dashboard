FROM jupyter/minimal-notebook

#Add Additional Image Labels
LABEL maintainer="Rowan Gaffney <rowan.gaffney@usda.gov>"

SHELL ["/bin/bash", "-c"]
USER root
SHELL ["/bin/bash", "-c"]

USER $NB_UID
#Install Python and R packages in the py_geo and r_geo environmets, respectively.
COPY environment.yml .
RUN conda config --set channel_priority strict && \
	conda install -c conda-forge --yes --quiet \
		'jupyterlab' \
    'jupyterlab=2.1' \
    'jupyter-server-proxy=1.3.2' \
    'xarray=0.15.1' \
    'rasterio=1.0' \
    'panel=0.9.5' \
    'holoviews=1.13.2' \
    'hvplot=0.5.2' \
    'bokeh=2.0.1' \
    'gdal=3.0.4' \
    'geopandas=0.7' \
    'dask=2.14' \
    'datashader=0.10' \
    'jupyter-panel-proxy=0.1.0' \
    'fsspec=0.7.2' \
    'geoviews=1.8.1' \
    'pandas=1.0.3' \
    'dask-gateway=0.7' \
    'dask-labextension' \
    'gcsfs=0.6' \
    'zarr=2.4' && \
	conda clean --all -afy && \
	npm cache clean --force && \
  	rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
  	rm -rf /home/$NB_USER/.cache/yarn && \
  	rm -rf /home/$NB_USER/.node-gyp && \
    	fix-permissions /home/$NB_USER && \
    	fix-permissions $CONDA_DIR

#Initialize Conda
USER $NB_UID
RUN conda init bash && exec bash

RUN git clone --branch gae https://github.com/rmg55/test_dashboard.git /rrsru_app

CMD EXPOSE 5006
EXPOSE 80

CMD Panel serve \
    --allow-websocket-origin="*" \
    --index=/rrsru_app/test_dashboard/index.html \
    --num-procs=0 \
    /rrsru_app/test_dashboard/test_dashboard.ipynb
